# ==============================================================================
# Environment
# ==============================================================================
export AWS_PAGER=""
export AWS_DEBUG=true
export AWS_DEBUG_REQUEST=true



# ==============================================================================
# Functions
# ==============================================================================

# eks_cluster_versions: Lists all EKS clusters across all regions with their control plane
# and worker node versions in JSON format
function eks_cluster_versions() {
  local out_json; out_json="["
  local start_context; start_context="$(kubectl config current-context)"
  local js_regions; js_regions="$(aws ec2 describe-regions --query 'Regions[]' --output json)"
  local region_names; region_names="$(jq -r '.[].RegionName' <<< ${js_regions})"
  local first_region; first_region=true
  local first_cluster; first_cluster=true
  local first_namespace; first_namespace=true

  echo "$(utc) starting context: $start_context"
  #echo $js_regions
  #echo $region_names

  out_json="["

  echo $region_names
  while IFS= read -r region; do
  #for region in $(aws ec2 describe-regions --query 'Regions[].RegionName' --output text --no-cli-pager); do

    # region data array
    echo "$(utc) region: ${region}"
    out_json="${out_json}\"$region\": ["

    for cluster in $(aws eks list-clusters --region $region --query 'clusters[]' --output text --no-cli-pager); do

      if [[ "$first_cluster" = true ]]; then
        first_cluster=false
      else
        out_json="${out_json},"
      fi

      echo "$(utc) cluster: ${cluster}"
      out_json="${out_json}\"$cluster\": "

      # Get control plane info
      control_plane=$(aws eks describe-cluster --name $cluster --region $region \
        --query 'cluster.{
          version:version,
          status:status,
          platformVersion:platformVersion,
          endpoint:endpoint,
          kubernetesNetworkConfig:kubernetesNetworkConfig,
          logging:logging.clusterLogging[].enabled,
          controlPlane:{
            version:version,
            platformVersion:platformVersion,
            endpoint:endpoint,
            status:status
          }
        }' \
        --output json \
        --no-cli-pager)

      #echo "$(utc) control plane: ${control_plane}"
      out_json="${out_json}\"control-plane\": ${control_plane},"

      # Update kubeconfig temporarily for this cluster
      echo -n "$(utc) context switch: region:${region} cluster:${cluster}"
      aws eks update-kubeconfig --name ${cluster} --region ${region} --no-cli-pager >/dev/null
      [[ $? ]] && echo " ${Green}⬤a${Reset}"

      # Get worker nodes info
      worker_nodes="$(kubectl get nodes -o json | jq '[.items[] | {
        name:.metadata.name,
        status:(.status.conditions[] | select(.type=="Ready")).status,
        version:.status.nodeInfo.kubeletVersion,
        instanceType:.metadata.labels["node.kubernetes.io/instance-type"],
        zone:.metadata.labels["topology.kubernetes.io/zone"]
      }]')"

      # Combine control plane and worker nodes info
      #echo "$(utc) worker node: ${worker_nodes}"
      out_json="${out_json}\", worker-nodes\": ${worker_nodes}"
    done

    # end region
    out_json="${out_json}]"
    if [[ "$first_region" = true ]]; then
      first_region=false
    else
      out_json="${out_json},"
    fi
  done <<< "${region_names}"


  out_json="${out_json}]"


  echo
  echo
  echo
  echo
  echo "$(utc) output json:"
  echo
  echo ${out_json}
  echo
  kubectx ${start_context} >/dev/null
  #echo ${out_json} | jq -rs 'add'
}



