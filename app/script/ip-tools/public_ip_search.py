import boto3

regions = [ 'ap-northeast-2', 'ap-northeast-1', 'us-east-2', 'eu-west-1', 'eu-west-2']
profiles = ['land', 'sticpay', 'land-supplement', 'bubbletap', 'wisebitcoin', 'adena_admin']
ips = ['1.1.1.1', '103.159.132.27']

for profile in profiles:
    for region in regions:
        session = boto3.Session(profile_name=profile, region_name=region)

        ec2 = session.resource('ec2')
        instances = ec2.instances.all()

        for instance in instances:
            if instance.state['Name'] != 'running':
                pass
            else:
                for tags in instance.tags:
                    if tags['Key'] == 'Name':
                        instance_tagname = tags['Value']
                    else:
                        pass
                for network in instance.network_interfaces_attribute:
                    publicip = network.get('Association')
                    if publicip == None:
                        pass
                    else:
                        public_ip = publicip.get('PublicIp')
                        for ip in ips:
                            if public_ip == ip:
                                print('profile: %s, region: %s, instance_name: %s, public_ip: %s' %(profile, region, instance_tagname, public_ip)) 
                                #print(profile, region, instance_tagname, public_ip)
                            else:
                                pass 
