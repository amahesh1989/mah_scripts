# Wrapper to create RITM for PDB registration in Cyberark
# Author - kumamahd
# Created  22/11/2021
# v1
#
#

import flask
import requests
import json
from flask import request, Response
import cx_Oracle
import os
app = flask.Flask(__name__)
app.config["DEBUG"] = True

@app.route('/health', methods=['GET'])
def home():
    return '''<h1>All good. API in healthy state.</h1>'''

@app.route('/api/v1/cr_ritm_cyb_pdb', methods=['POST'])
def create_ritm():
    d=json.loads(request.data.decode('utf-8'))
    db_name=d['db_name']
    req_by=d['requested_by']
    url='https://dbunityworker.service-now.com/api/global/nwr'
    proxyDict = {"https" : "http://userproxy.intranet.db.com:8080"}
    snow_api_key= os.environ['snow_key']
    

    api_k='Basic ' + snow_api_key


    headers = {'Content-Type': 'application/json', 'Authorization': api_k}

    payload_text='{"u_cmdb_ci": "Oracle Cloud-On Premise","u_request_type": "Configure","u_request_sub_type" : "Install/Set-up",  "u_assignment_group": "DB_KEY_MANAGEMENT_L1_SUPPORT",  "u_requested_for_email": "'+req_by+'",  "u_details": "As part of New Build Process w.r.t EXACC, we need to validate Cyber Ark access to the below listed databases:\\\\n Database Names: \\\\n ' + db_name + '  \\\\n\\\\nIf a database is not listed, please create 2 CyberArk accounts for storage of passwords for Primary and Archive DSM access for \\\\n ' + db_name + ' \\\\n\\\\n If it is listed, please provide a confirmation mail to oracloud-team-certprod@list.db.com, alexander-a.nachtigall@db.com, mohamud.galaid@db.com, dhs-product-management@list.db.com",  "u_priority": "3"}'

    # print(payload_text)

    payload=json.dumps(payload_text)
    # print(payload)
    passw = os.environ['OEM_PASS']
    
    
    oem_conn='ecc_owner/'+passw+'@(DESCRIPTION=(CONNECT_TIMEOUT=3)(RETRY_COUNT=3)(ADDRESS_LIST=(FAILOVER=on)(LOAD_BALANCE=off)(ADDRESS=(PROTOCOL=TCP)(HOST=longridop01-sc.uk.db.com)(PORT=1600))(ADDRESS=(PROTOCOL=TCP)(HOST=longridop02-sc.uk.db.com)(PORT=1600)))(CONNECT_DATA=(SERVICE_NAME=EMTOOLS_APP.uk.db.com)))'
    ret_op={}

    conn=cx_Oracle.connect(oem_conn)
    con1=conn.cursor()
    cmd="select count(1) from ECC_PROVISION_RITM_TRACK where lower(db_name)=:db"
    con1.execute(cmd,db=db_name.lower())
    res=con1.fetchall()
    if res:
        value=res[0][0]
        if value:
            cmd="select ritm from ECC_PROVISION_RITM_TRACK where lower(db_name)=:db"
            con1.execute(cmd,db=db_name.lower())
            res=con1.fetchall()
            if res:
                value=res[0][0]
                op='RITM for '+ db_name + ' already exists - '+value+'. No action required'
                ret_op['status']='failed'
                ret_op['RITM']='NA'

        else:
            op='RITM for '+ db_name + ' not found. Eligible for new RITM creation'
            # print(op)
           
            response = requests.request("POST", url, headers=headers,proxies=proxyDict, data=payload_text)
            res=response.json()
            r_op=res['result']
            if r_op:
                if r_op['status']=='inserted':
                    ritm=r_op['RITM_Number']
                    ret_op['RITM']=ritm
                    ret_op['status']='success'
                    con2=conn.cursor()
                    cmd="insert into ECC_PROVISION_RITM_TRACK(db_name,ritm,status) values(:db_name,:ritm,:stat)"
                    con2.execute(cmd,db_name=db_name,ritm=ritm,stat='SUBMITTED')
                    conn.commit()
                    
                else:
                    op='Unable to create RITM. Please check with developer'
                    ret_op['status']='failed'
                    ret_op['RITM']='NA'
           
    else:
        op='Unable to track if RITM created or not. Please check developer.'
        ret_op['status']='failed'
    
    ret_op['info']=op
 
    return ret_op


if __name__ == "__main__":
        app.run(host='0.0.0.0', port=8080, debug=True, use_reloader=False)

