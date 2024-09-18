
  
    

        create or replace transient table GDP_SANDBOX.STAGING.fct_source_fanout
         as
        (-- this model finds cases where a source is used in multiple direct downstream models
with direct_source_relationships as (
    select  
        *
    from GDP_SANDBOX.STAGING.int_all_dag_relationships
    where distance = 1
    and parent_resource_type = 'source'
    and child_resource_type = 'model'
    and not parent_is_excluded
    and not child_is_excluded
    -- we order the CTE so that listagg returns values correctly sorted for some warehouses
    order by child
),

source_fanout as (
    select
        parent,
        
    listagg(
        child,
        ', '
        )
        within group (order by child) as model_children
    from direct_source_relationships
    group by 1
    having count(*) > 1
)

select * from source_fanout



    

    
    

    

    


        );
      
  