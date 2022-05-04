# Wrapper to create RITM in service now
# Author - amahesh1989@gmail.com
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
    return '''<h1>API healthy</h1>'''

@app.route('/cr_ritm_cyb_pdb', methods=['POST'])
def create_ritm():
    d=json.loads(request.data.decode('utf-8'))
    db_name=d['db_name']
    req_by=d['requested_by']
    env=d['env']
    order=d['order_n']
    url=snow_link + '/api/global/nwr'
    proxyDict = {"https" : proxy_url}
    snow_api_key= os.environ['snow_key']
    
    if env=="PROD":
        dbs=db_name + ' ' + db_name + 'C'
    else:
        dbs=db_name
    

    api_k='Basic ' + snow_api_key


    headers = {'Content-Type': 'application/json', 'Authorization': api_k}

    payload_text='{\
            "u_cmdb_ci":"",\n \
            "u_request_type":"",\n\
            "u_request_sub_type":"",\n\
            "u_assignment_group":"",\n\
            "u_priority":"3",\n\
            "u_requested_for_email":"amahesh1989@gmail.com",\n\
            "u_details":""\
    }'

    # print(payload_text)

    # payload=json.dumps(payload_text)
    # print(payload)
    passw = os.environ['OEM_PASS']
    
    
    oem_conn='ecc_owner/'+passw+'@'+ oem_conn
    ret_op={}

    conn=cx_Oracle.connect(oem_conn)
    con1=conn.cursor()
    cmd="select count(1) from PROVISION_RITM_TRACK where lower(db_name)=:db"
    con1.execute(cmd,db=db_name.lower())
    res=con1.fetchall()
    if res:
        value=res[0][0]
        if value:
            cmd="select ritm from PROVISION_RITM_TRACK where lower(db_name)=:db"
            con1.execute(cmd,db=db_name.lower())
            res=con1.fetchall()
            if res:
                value=res[0][0]
                op='RITM for '+ db_name + ' already exists - '+value+'. No action required'
                ret_op['status']='failed'
                ret_op['RITM']='NA'

        else:
            op='RITM for '+ db_name + ' not found. Eligible for new RITM creation'
            print(op)
           
            response = requests.request("POST", url, headers=headers,proxies=proxyDict, data=payload_text)
            res=response.json()
            r_op=res['result']

            if r_op:
                if r_op['status']=='inserted':
                # if r_op=='inserted':
                    ritm=r_op['RITM_Number']
                    # ritm='1234'
                    ret_op['RITM']=ritm
                    ret_op['status']='success'
                    
                    con2=conn.cursor()
                    cmd="insert into PROVISION_RITM_TRACK(db_name,ritm,status,order_n,created_by) values(:db_name,:ritm,:stat,:ord,:creator)"
                    con2.execute(cmd,db_name=db_name,ritm=ritm,stat='SUBMITTED',ord=order,creator=req_by)
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

