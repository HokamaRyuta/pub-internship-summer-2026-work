with source as (

    select *
    from {{ source('rakuten_ec', 'stores') }}

),

final as (
    select
        store_id,
        store_name,
        ec_site_id,

        -- 今回の対象ECサイトは楽天市場のみ
        'Rakuten' as ec_site_name

    from source
)
select *
from final
