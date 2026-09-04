{{
    config(
        materialized='table'
    )
}}

with categories as (
    select * from {{ ref('stg_rakuten_ec__categories') }}
),

c1 as (
    select
        category_id as category_1_id,
        category_name as category_1_name
    from categories
    where category_level = 1
),

c2 as (
    select
        category_id as category_2_id,
        category_name as category_2_name,
        parent_category_id as parent_to_c1
    from categories
    where category_level = 2
),

c3 as (
    select
        category_id as category_3_id,
        category_name as category_3_name,
        parent_category_id as parent_to_c2
    from categories
    where category_level = 3
),

c4 as (
    select
        category_id as category_4_id,
        category_name as category_4_name,
        parent_category_id as parent_to_c3
    from categories
    where category_level = 4
),

flat_level_1 as (
    select
        category_1_id as category_id,
        category_1_name as category_name,
        1 as category_level,
        category_1_name as category_level_1,
        cast(null as varchar) as category_level_2,
        cast(null as varchar) as category_level_3,
        cast(null as varchar) as category_level_4
    from c1
),

flat_level_2 as (
    select
        c2.category_2_id as category_id,
        c2.category_2_name as category_name,
        2 as category_level,
        c1.category_1_name as category_level_1,
        c2.category_2_name as category_level_2,
        cast(null as varchar) as category_level_3,
        cast(null as varchar) as category_level_4
    from c2
    inner join c1 on c2.parent_to_c1 = c1.category_1_id
),

flat_level_3 as (
    select
        c3.category_3_id as category_id,
        c3.category_3_name as category_name,
        3 as category_level,
        c1.category_1_name as category_level_1,
        c2.category_2_name as category_level_2,
        c3.category_3_name as category_level_3,
        cast(null as varchar) as category_level_4
    from c3
    inner join c2 on c3.parent_to_c2 = c2.category_2_id
    inner join c1 on c2.parent_to_c1 = c1.category_1_id
),

flat_level_4 as (
    select
        c4.category_4_id as category_id,
        c4.category_4_name as category_name,
        4 as category_level,
        c1.category_1_name as category_level_1,
        c2.category_2_name as category_level_2,
        c3.category_3_name as category_level_3,
        c4.category_4_name as category_level_4
    from c4
    inner join c3 on c4.parent_to_c3 = c3.category_3_id
    inner join c2 on c3.parent_to_c2 = c2.category_2_id
    inner join c1 on c2.parent_to_c1 = c1.category_1_id
),

final as (
    select * from flat_level_1
    union all
    select * from flat_level_2
    union all
    select * from flat_level_3
    union all
    select * from flat_level_4
)

select * from final
