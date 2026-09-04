with users as (

    select * from {{ ref('stg_rakuten_ec__users') }}

),

gene_definition as (

    select * from {{ ref('gene_definition') }}

),

region_definition as (

    select * from {{ ref('region_definition') }}

),

final as (

    select
        users.user_id_hash
        , users.age
        , users.gender_name
        , users.state_name
        , users.marriage_status
        , users.profession_name
        , users.occupation_name
        , region_definition.region_name
        , gene_definition.gene as age_category

    from users
    left join region_definition
        on users.state_name = region_definition.state_name
    left join gene_definition
        on users.age between gene_definition.age_lower_limit and gene_definition.age_upper_limit

)

select * from final
