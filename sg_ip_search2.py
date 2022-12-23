import boto3
import slack_sdk

regions = ['ap-northeast-2']
profiles = ['haebokka']

for profile in profiles:
    for region in regions:
        session = boto3.Session(profile_name=profile, region_name=region)

        #ec2 = session.resource('ec2')
        #instances = ec2.instances.all()
         
        ec2 = session.client('ec2')
        #security_groups = session.security_groups.all()
        
        def sg_check():
            response = ec2.describe_security_groups()['SecurityGroups']

            for i in response:
                sgid = i['GroupId']
                for j in i['IpPermissions']:
                    try:
                        port = 'ANY' if j ['FromPort'] == -1 else j['FromPort']
                        protocol = j['IpProtocol']
                        ipaddr = j['IpRanges'][0]['CidrIp']

                        if ipaddr =='0.0.0.0/0':
                            print('sgid : %s, port : %s, protocol : %s, ipaddr : %s' %(sgid, port, protocol, ipaddr))

                    except:
                        pass

if __name__ == "__main__":
    sg_check()


