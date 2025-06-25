from flask import Flask, request, jsonify
import google.auth
import google.auth.transport.requests
from kubernetes import client
import logging
from googleapiclient import discovery

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = Flask(__name__)

@app.route('/scale', methods=['POST'])
def scale_hpa():
    try:
        data = request.get_json()
        if not data:
            return jsonify({"error": "Invalid JSON"}), 400

        project_id = data.get("projectId")
        cluster = data.get("cluster")
        region = data.get("region")
        namespace = data.get("namespace")
        hpa_name = data.get("hpaName")
        min_replicas = data.get("minReplicas")
        max_replicas = data.get("maxReplicas")

        if not all([project_id, cluster, region, namespace, hpa_name, min_replicas, max_replicas]):
            return jsonify({"error": "Missing one or more required fields"}), 400

        logger.info(f"Scaling HPA [{hpa_name}] in {namespace} (Cluster: {cluster}) to min: {min_replicas}, max: {max_replicas}")

        # 인증 및 토큰 갱신
        credentials, _ = google.auth.default(scopes=['https://www.googleapis.com/auth/cloud-platform'])
        auth_req = google.auth.transport.requests.Request()
        credentials.refresh(auth_req)

        # GKE 클러스터 API 호출
        container_client = discovery.build('container', 'v1', credentials=credentials)
        cluster_name = f"projects/{project_id}/locations/{region}/clusters/{cluster}"

        cluster_info = container_client.projects().locations().clusters().get(name=cluster_name).execute()
        endpoint = cluster_info['endpoint']

        configuration = client.Configuration()
        configuration.host = f"https://{endpoint}"
        configuration.api_key_prefix['authorization'] = 'Bearer'
        configuration.api_key['authorization'] = credentials.token
        configuration.verify_ssl = False
        client.Configuration.set_default(configuration)

        api_client = client.ApiClient(configuration)
        api_instance = client.CustomObjectsApi(api_client)

        # HPA 스케일 조정
        body = {
            "spec": {
                "minReplicas": min_replicas,
                "maxReplicas": max_replicas
            }
        }

        api_response = api_instance.patch_namespaced_custom_object(
            group="autoscaling",
            version="v1",
            namespace=namespace,
            plural="horizontalpodautoscalers",
            name=hpa_name,
            body=body
        )

        logger.info("HPA updated successfully")
        return jsonify({"message": "HPA updated successfully"}), 200

    except Exception as e:
        logger.error(f"Error scaling HPA: {str(e)}")
        return jsonify({"error": "Internal server error", "details": str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080, debug=True)