# Run this script to update the running instances
  
# $ python update_running_instances.py "cd /tmp && wget file && ls" biobakery.key password "10.0.0.0"

# The first arg is the command to execute, the second is a file with the private ssh key
# the third is the password for the key , and the fourth (optional)  is a subset of IPs to run on (empty if no subset filter to be applied).

import sys
import subprocess
import json

user_command=sys.argv[1]
key_file=sys.argv[2]
password=sys.argv[3]

try:
    subset_filter=sys.argv[4].split(",")
except IndexError:
    subset_filter=[]

# get a list of all biobakery instances that are running
instances = json.loads(subprocess.check_output(["gcloud","compute","instances","list","--format","json"]))
instances_list = [(i["name"],i["status"],i["networkInterfaces"][0]["networkIP"]) for i in instances]
biobakery_instances = filter(lambda x: "biobakery" in x[0].lower() and "running" in x[1].lower(), instances_list)
if len(biobakery_instances)==0:
    sys.exit("ERROR: no instances with 'biobakery' in the name have been found")

for instance in biobakery_instances:
    if not subset_filter or (subset_filter and instance[2] in subset_filter):
        print("# Update Image: Google Cloud Instance NAME: {0} IP: {1}".format(instance[0], instance[2]))
        command="sshpass -P passphrase -p {0} ssh -o StrictHostKeyChecking=no {1} -i {2} '{3}'".format(password, instance[2], key_file, user_command)
        print(command)
        try:
            print(subprocess.check_output(command,shell=True))
        except subprocess.CalledProcessError as e:
            print("Error running command on instance : "+instance[2])
            print(e)
