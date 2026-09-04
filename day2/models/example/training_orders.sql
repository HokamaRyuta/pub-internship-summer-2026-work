with load_order as (
    select
        *
    from
        {{ source('training', 'orders') }}
),

load_customer as (
    select
        *
    from
        {{ source('training', 'customers') }}
),

join_customer as (
    select
        t1.*,
        -- 列を追加しよう
        t2.customer_name,
        t2.customer_age,
        t2.customer_birthday,
        t2.customer_gender,
        t2.customer_location
    from
        load_order as t1
        -- customerをjoinしてみよう
    inner join load_customer as t2
    on
        t1.customer_id = t2.customer_id
),

final as (
    select
        *
    from
        join_customer
)

select *
from final
