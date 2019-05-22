
# Run this script to update the guacamole configuration to include the latest internal IP addresses
# $ python configure_guacamole.py > mysql_update_commands.txt
# $ mysql -u USER -p PWD < mysql_update_commands.txt

import sys
import subprocess
import json

command_host = "update guacamole_connection_parameter set parameter_value='NEW_IP' where parameter_name='hostname' and connection_id='NEW_ID';"
command_sftp = "update guacamole_connection_parameter set parameter_value='NEW_IP' where parameter_name='sftp-hostname' and connection_id='NEW_ID';"

# get a list of all biobakery instances that are running
instances = json.loads(subprocess.check_output(["gcloud","compute","instances","list","--format","json"]))
instances_list = [(i["name"],i["status"],i["networkInterfaces"][0]["networkIP"]) for i in instances]
biobakery_instances = filter(lambda x: "biobakery" in x[0].lower() and "running" in x[1].lower(), instances_list)
if len(biobakery_instances)==0:
    sys.exit("ERROR: no instances with 'biobakery' in the name have been found")

# write out file of commands to update configuration to running instances
guac_ids = []
for line in open("instance_ids.txt"):
    guac_ids.append(line.rstrip().split("\t"))

print("use guacamole_db;")
for instance,guac in zip(biobakery_instances,guac_ids):
    print("# Update Configuration: Google Cloud Instance NAME: {0} IP: {1} to Guacamole Instance NAME: {2} ID: {3}".format(instance[0], instance[2], guac[1], guac[0]))
    print(command_host.replace("NEW_IP",instance[2]).replace("NEW_ID",guac[0]))
    print(command_sftp.replace("NEW_IP",instance[2]).replace("NEW_ID",guac[0]))
