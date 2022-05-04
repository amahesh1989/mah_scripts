for (( i=1;i<=$reco_n;i++ ));
do
        gcloud compute disks create $INSTANCE_NAME-reco010${i} --type=pd-ssd --size=${RECO_LUN_SIZE}GB --zone=$ZONE
done

#Provision TEMP REDO01LOG and REDOLOG02

gcloud compute disks create $INSTANCE_NAME-redolog0101 --type=pd-ssd --size=${REDOLOG_LUN_SIZE}GB --zone=$ZONE

gcloud compute disks create $INSTANCE_NAME-redolog0201 --type=pd-ssd --size=${REDOLOG_LUN_SIZE}GB --zone=$ZONE

gcloud compute disks create $INSTANCE_NAME-temp0101 --type=pd-ssd --size=${TEMP_LUN_SIZE}GB --zone=$ZONE



#Create instance from machine image

gcloud beta compute instances create $INSTANCE_NAME --project=${PROJECT} --zone $ZONE --source-machine-image projects/dbapoc-289518/global/machineImages/${MACHINE_IMAGE} --service-account $SA --machine-type=${MACHINE_TYPE} --subnet=${SUBNET} --no-address --no-restart-on-failure --maintenance-policy=TERMINATE --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append --min-cpu-platform=Automatic --tags=egress-nat-gce,ssh,oracle --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --reservation-affinity=any --metadata-from-file startup-script=post_gce_provision.sh --metadata DB_NAME=$DB_NAME,APP_PREFIX=$APP_PREFIX,SERVICE_NAME=$SERVICE_NAME,SGA=$SGA

#Attach all disks for ASM

for (( i=1;i<=$reg_data_n;i++ ));
do
        gcloud compute instances attach-disk $INSTANCE_NAME --disk=$INSTANCE_NAME-regdata010${i} --device-name=regdata010${i} --mode=rw --zone=$ZONE
        gcloud compute instances set-disk-auto-delete $INSTANCE_NAME --disk=$INSTANCE_NAME-regdata010${i} --zone=$ZONE
done

for (( i=1;i<=$reco_n;i++ ));
do
        gcloud compute instances attach-disk $INSTANCE_NAME --disk=$INSTANCE_NAME-reco010${i} --device-name=reco010${i} --mode=rw --zone=$ZONE
        gcloud compute instances set-disk-auto-delete $INSTANCE_NAME --disk=$INSTANCE_NAME-reco010${i} --zone=$ZONE
done

gcloud compute instances attach-disk $INSTANCE_NAME --disk=$INSTANCE_NAME-redolog0101 --device-name=redolog0101 --mode=rw --zone=$ZONE
gcloud compute instances set-disk-auto-delete $INSTANCE_NAME --disk=$INSTANCE_NAME-redolog0101 --zone=$ZONE

gcloud compute instances attach-disk $INSTANCE_NAME --disk=$INSTANCE_NAME-redolog0201 --device-name=redolog0201 --mode=rw --zone=$ZONE
gcloud compute instances set-disk-auto-delete $INSTANCE_NAME --disk=$INSTANCE_NAME-redolog0201 --zone=$ZONE

gcloud compute instances attach-disk $INSTANCE_NAME --disk=$INSTANCE_NAME-temp0101 --device-name=temp0101 --mode=rw --zone=$ZONE
gcloud compute instances set-disk-auto-delete $INSTANCE_NAME --disk=$INSTANCE_NAME-temp0101 --zone=$ZONE
