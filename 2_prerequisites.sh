
SP_NAME="sp_cockroachdb"

SP_TENANT_ID=$(az account list -o json --query "[?user.name=='<USERNAME>'].tenantId" --output tsv)
SP_SUBSCRIPTION_ID=$(az account list -o json --query "[?user.name=='<USERNAME>'].id" --output tsv)

SP_INFO=$(az ad sp create-for-rbac --name="$SP_NAME" --role="Contributor" --scopes="/subscriptions/$SUBSCRIPTION_TENANT" 2>&1)



 

SP_CLIENT_ID=$(az ad sp list --filter "displayname eq '$SP_NAME'" -o json --query '[].appId | [0]' --output tsv) 

JSTART="{";JEND="\"a\":\"b\"}";
PW_PRE_1=$JSTART$(echo "$SP_INFO" | grep "password")$JEND 
PW_PRE_2=$(echo $PW_PRE_1 | jq '.password' 2>&1) 
SP_CLIENT_SECRET=$(echo $PW_PRE_2 | tr -d '"' 2>&1)



echo "TENANT_ID:" $SP_TENANT_ID
echo "SUBSCRIPTION_ID:" $SP_SUBSCRIPTION_ID
echo "CLIENT_ID:" $SP_CLIENT_ID
echo "CLIENT_SECRET:" $SP_CLIENT_SECRET

#chmod +x 2_prerequisites.sh 
#source 2_prerequisites.sh 


#az login --service-principal -u $SP_CLIENT_ID -p $SP_CLIENT_SECRET --tenant $SP_TENANT_ID

#az ad sp delete --id $SP_CLIENT_ID
