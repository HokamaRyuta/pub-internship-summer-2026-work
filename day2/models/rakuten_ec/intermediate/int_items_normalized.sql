with load_pi_i as (
    select
        pi.*
        , i.item_name
        , i.item_url
        , i.is_sale
        , i.store_id
        , i.category_id
    from
        {{ ref('stg_rakuten_ec__purchase_items')}} as pi
        inner join {{ ref('stg_rakuten_ec__items') }} as i
        on pi.item_id = i.item_id
), add_normalized_name as (
    select
        *
        , case
            when item_url is not null then
                first_value(item_name) over (partition by item_url
                order by length(item_name) asc, item_name asc)
            else item_name
          end as normalized_item_name // 注意！！
    from load_pi_i
), add_discount_value as (
    select
        *
        , case
            when item_url is not null then
                (MAX(unit_price) over (partition by item_url)) - unit_price
            else 0
            end as discount_value
    from add_normalized_name
), final as (
    select
        item_id
        , normalized_item_name as item_name
        , item_url
        , store_id
        , category_id
        , purchase_item_id
        , purchase_id
        , unit_price
        , amount
        , total_price
        , is_sale
        , discount_value
    from add_discount_value
)

select *
from final
