import requests

proxyDict = {"https" : ""}
headers = {
'Content-Type': 'application/json',
'Authorization': 'Basic '
}

def close_inc(im,close_type,msg):
    sys_id=get_sys(im)
    url = snow_url
    if close_type=='duplicate':
        payload='{\"u_reference_sysid\": \"'+ sys_id +'\",\"u_close_code\": \"Cancelled\",\"u_closure_code_2\": \"Duplicate\",\"u_solution_code\": \"No Action Taken\",\"u_incident_state\": \"6\",\"u_resolution_description\": \" Working with master incident INC \",\"u_closure_code_justification\": \"Working with master incident INC\"}'
    elif close_type=='no_fault':
        # Below payload not completed yet
        # payload='{\"u_reference_sysid\": \"'+ sys_id +'\",\"u_close_code\": \"No Fault Found\",\"u_closure_code_2\": \"False Alert\",\"u_solution_code\": \"No Action Taken\",\"u_incident_state\": \"6\",\"u_resolution_description\": \"'+ msg +'\" ,\"u_closure_code_justification\": \"'+ msg +'\"}'
        payload='{\"u_reference_sysid\": \"'+ sys_id +'\",\"u_close_code\": \"No Fault Found\",\"u_incident_state\": \"6\",\"u_resolution_description\": \"'+ msg +'\"}'
    else:
        print('Not a valid close type')
    #payload="{"u_reference_sysid": sys_id ,"u_close_code": "No Fault Found","u_closure_code_2": "False Alert","u_solution_code": "No Action Taken","u_incident_state": "6","u_resolution_description": "Caused due to CHG. No action needed.Closed intiated by amahesh1989@gmail.com","u_closure_code_justification": "Caused due to CHG. No action needed.Closed intiated by amahesh1989@gmail.com"}"

    # print(payload)

    response = requests.request("POST", url, headers=headers, data=payload, proxies=proxyDict)
    print(response.json())

def check_harmless(im):
    sys_id=get_sys(im)
    url=snow_url + sys_id +'^field=comments^newLIKEHARMLESS'
   

    response = requests.request("GET", url, headers=headers, proxies=proxyDict)
    res = response.json()
    if res['result']:
        # print(im + ' has HARMLESS notification')
        return 1
    else:
        # print(im + ' has no HARMLESS notification')
        return 0
        # # print([res['result'][i] if res['result'][i]['field']=='comments' for i in range(len(res['result']))])
        # r=res['result']
        # h_count=0
        # for i in range(len(r)):
        #     # print(i)
        #     # msg=''
        #     if (r[i]['field']=='comments') and (r[i]['user_id']=='netcool_interface') and ("HARMLESS" in r[i]['new']):
        #         msg=im + ' --> ' + r[i]['new'] + ' ' + r[i]['update_time']
        #         print(msg)
        #         h_count+=1
        #     # else:
        #     #     msg=''
        # if h_count > 0:
        #     print(h_count)
        # else:
        #     print(im + ' has no HARMLESS notification')



def get_sys(im):
    url = snow_url + im
    response = requests.request("GET", url, headers=headers, proxies=proxyDict)
    res=response.json()
    if res:
        return(res['result'][0].get('sys_id'))

def get_ims():
    included_groups=['GROUP1']
    inc_like='fraba1pc'
    a_grp=[]
    #get group_ids
    for grp in included_groups:
        url= snow_url + grp
        response = requests.request("GET", url, headers=headers,  proxies=proxyDict)
        res=response.json()
        #for x in res['result']:
        #print(res['result'][0]['sys_id'])
        if res['result']:
            a_grp.append(res['result'][0]['sys_id'])

    assign_group=''
    for grp in a_grp:
        if assign_group:
            assign_group=assign_group + '%5EORassignment_group%3D' + grp
        else:
            assign_group=grp
        #assign_group='%5EORassignment_group%3D8c89ed8795c82100d0debe5efb5dcbd6'
    # print(assign_group)    
    
    url = snow_url + assign_group + '%5Eactive%3Dtrue%5Estate!%3D6%5Eshort_descriptionLIKE'+inc_like+'&sysparm_view=lite'

    exclude_list=['INC1','INC2']

    response = requests.request("GET", url, headers=headers, proxies=proxyDict)
    val = response.json()
    x=[]
    for res in val['result']:
        if res:
            sys_id=res['sys_id']
            im_num=res['number']
            #return(sys_id)
            x.append(im_num)
        #resp = Response(response=len(x), status=200, mimetype="application/json")
    new_list=list(set(x) - set(exclude_list))
    return(new_list)
list_ims=get_ims()
print(len(list_ims))
# list_ims.sort()
include_list=[]
# list_ims=include_list
print(list_ims)
# list_ims=['INC']

# for im in list_ims:
#     ret=check_harmless(im)
#     if ret:
#         print (im + ' has HARMLESS notification')
#         close_inc(im,'no_fault','Alert cleared in OEM now')

#     else:
#         print (im + ' has NO HARMLESS notification. Cannot be closed now')


# for inc in list_ims:
#     close_inc(inc,'duplicate')

for inc in list_ims:
     close_inc(inc,'no_fault','CHG')



