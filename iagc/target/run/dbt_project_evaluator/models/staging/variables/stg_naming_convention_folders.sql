
  create or replace   view GDP_SANDBOX.STAGING.stg_naming_convention_folders
  
   as (
    





  

  

  

  

  


with vars_folders_table as (
    
        select 'base_folder_name' as var_name, 'base' as var_value
        union all
        select 'staging_folder_name' as var_name, 'staging' as var_value
        union all
        select 'intermediate_folder_name' as var_name, 'intermediate' as var_value
        union all
        select 'marts_folder_name' as var_name, 'marts' as var_value
        
)

select
    var_name as folder_name, 
    

    replace(
        var_name,
        
  
    '_folder_name'
  
,
        ''
    )


 as model_type,
    var_value as folder_name_value
from vars_folders_table
  );

