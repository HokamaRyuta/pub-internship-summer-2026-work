select
    ITEM_ID as item_id,
    ITEM_NAME as item_name,
    ITEM_URL as item_url,
    STORE_ID as store_id,
    CATEGORY_ID as category_id,

    case
        when ITEM_NAME like '%セール%' then true
        else false
    end as is_sale

from {{ source('rakuten_ec', 'items') }}
