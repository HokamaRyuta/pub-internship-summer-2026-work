with source as (

    select *
    from {{ source('rakuten_ec', 'purchases') }}

),

final as (
    select
        purchase_id,
        
        -- message_id がsource内に存在しないため代用
        purchase_id as message_id,
        purchased_at,

        -- 購入日時から日付を抽出
        purchased_at::date as purchase_date,

        -- 月初日を購入月として設定
        date_trunc('month', purchased_at)::date as purchase_month,

        user_id,
        destination_postal_code

    from source
)
select *
from final
