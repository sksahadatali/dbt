
  create or replace   view GDP_SANDBOX.STAGING.int_direct_relationships
  
   as (
    -- one record for each resource in the graph and its direct parent
with 

all_graph_resources as (
    select
        resource_id,
        resource_name,
        resource_type,
        file_path,
        directory_path, 
        file_name,
        model_type,
        materialized,
        is_public, 
        access, 
        source_name,
        is_excluded
    from GDP_SANDBOX.STAGING.int_all_graph_resources
),

direct_model_relationships as (
    select  
        resource_id,
        direct_parent_id,
        is_primary_relationship
    from GDP_SANDBOX.STAGING.stg_node_relationships
),

direct_exposure_relationships as (
    select  
        resource_id,
        direct_parent_id,
        is_primary_relationship
    from GDP_SANDBOX.STAGING.stg_exposure_relationships
),

direct_metrics_relationships as (
    select  
        resource_id,
        direct_parent_id,
        is_primary_relationship
    from GDP_SANDBOX.STAGING.stg_metric_relationships
),

-- for all resources in the graph, find their direct parent
direct_relationships as (
    select
        all_graph_resources.resource_id,
        all_graph_resources.resource_name,
        all_graph_resources.resource_type,
        all_graph_resources.file_path,
        all_graph_resources.directory_path, 
        all_graph_resources.file_name,
        all_graph_resources.model_type,
        all_graph_resources.materialized,
        all_graph_resources.is_public, 
        all_graph_resources.access, 
        all_graph_resources.source_name,
        all_graph_resources.is_excluded,
        case 
            when all_graph_resources.resource_type = 'source' then null
            when all_graph_resources.resource_type = 'exposure' then exposures.direct_parent_id
            when all_graph_resources.resource_type = 'metric' then metrics.direct_parent_id
            when all_graph_resources.resource_type in ('model', 'snapshot', 'test') then models.direct_parent_id
            else null
        end as direct_parent_id,
        (
            all_graph_resources.resource_type = 'test'
            and models.is_primary_relationship
        ) as is_primary_test_relationship
    from all_graph_resources
    left join direct_model_relationships as models
        on all_graph_resources.resource_id = models.resource_id
    left join direct_exposure_relationships as exposures
        on all_graph_resources.resource_id = exposures.resource_id
    left join direct_metrics_relationships as metrics
        on all_graph_resources.resource_id = metrics.resource_id
),

final as (
    select
        md5(cast(coalesce(cast(resource_id as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(direct_parent_id as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as unique_id,
        *
    from direct_relationships
)

select * from final
  );

