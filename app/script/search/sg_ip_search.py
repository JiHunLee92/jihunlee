import boto3

regions = ['ap-northeast-1']
profiles = ['sticpay']
ips = ['0.0.0.0/0']

for profile in profiles:
    for region in regions:
        session = boto3.Session(profile_name=profile, region_name=region)

        ec2 = session.client('ec2')
        security_groups = ec2.describe_security_groups()

        for sg in security_groups['SecurityGroups']:
            sgid = sg.get('GroupId')
            group_name = sg.get('GroupName')
            ippermission = sg.get('IpPermissions')
            for info in ippermission:
                protocol = info.get('IpProtocol') 
                port = info.get('FromPort')
                ipaddr = info.get('IpRanges')
                for ip in ipaddr:
                    cidr = ip.get('CidrIp')
                    for ip in ips:
                        if cidr == ip:
                            print(profile, region, group_name, port, protocol, cidr)
                        else:
                            pass  
                 
