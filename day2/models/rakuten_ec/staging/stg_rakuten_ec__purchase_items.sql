with final as (
    select
        purchase_item_id
        , purchase_id
        , item_id
        , unit_price
        , amount
        , total_price
    from
        {{ source('rakuten_ec', 'purchase_items')}}
)

select *
from final
