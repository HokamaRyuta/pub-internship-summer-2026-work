{{
    config(
        materialized='view'
    )
}}

with source as (
    select * from {{ source('rakuten_ec', 'categories') }}
),

renamed as (
    select
        category_id,
        category_name,
        category_level,
        parent_category_id
    from source
)

select * from renamed
