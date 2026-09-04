with items as (
    select *
    from {{ ref('int_items_normalized') }}
),

purchases as (
    select *
    from {{ ref('stg_rakuten_ec__purchases') }}
),

users as (
    select *
    from {{ ref('int_users_enriched') }}
),

stores as (
    select *
    from {{ ref('stg_rakuten_ec__stores') }}
),

categories as (
    select *
    from {{ ref('int_categories_flattened') }}
),

final as (
    select
        -- ==========================================
        -- 公式テーブル定義 23カラム
        -- ==========================================

        -- 購入明細PKを大福帳のレコードIDとして使用
        items.purchase_item_id::varchar as id,

        purchases.message_id,
        purchases.purchased_at,

        stores.ec_site_name,

        items.unit_price,
        items.amount,
        items.total_price,

        users.user_id_hash,

        -- 名寄せ後の商品名
        items.item_name,
        items.item_url,

        purchases.destination_postal_code,

        stores.store_name,

        users.gender_name,
        users.age,
        users.age_category,
        users.state_name,
        users.marriage_status,
        users.profession_name,
        users.occupation_name,

        categories.category_level_1,
        categories.category_level_2,
        categories.category_level_3,
        categories.category_level_4,

        -- ==========================================
        -- 分析用追加 5カラム
        -- ==========================================

        purchases.purchase_date,
        purchases.purchase_month,

        users.region_name,

        items.is_sale,
        items.discount_amount

    from items

    left join purchases
        on items.purchase_id = purchases.purchase_id

    left join users
        on purchases.user_id = users.user_id_hash

    left join stores
        on items.store_id = stores.store_id

    left join categories
        on items.category_id = categories.category_id

    -- 商品カテゴリ1がNULLのレコードは除外
    where categories.category_level_1 is not null
)

select *
from final
