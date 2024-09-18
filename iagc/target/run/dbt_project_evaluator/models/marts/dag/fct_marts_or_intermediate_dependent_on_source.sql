
  
    

        create or replace transient table GDP_SANDBOX.STAGING.fct_marts_or_intermediate_dependent_on_source
         as
        (-- cases where a marts/intermediate model directly references a raw source
with direct_relationships as (
    select  
        *
    from GDP_SANDBOX.STAGING.int_all_dag_relationships
    where distance = 1
    and not parent_is_excluded
    and not child_is_excluded
),
final as (
    select
        parent,
        parent_resource_type,
        child,
        child_model_type
    from direct_relationships
    where parent_resource_type = 'source'
    and child_model_type in ('marts', 'intermediate')
)
select * from final



    

    
    

    

    


        );
      
  