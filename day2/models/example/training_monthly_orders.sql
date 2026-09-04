with load_order as (
    select
        *
    from
        {{ ref('training_orders') }} -- 作成済みのmodelを参照する場合はrefを使います
),

monthly_order as (
    select
        TO_CHAR(order_time, 'YYYY-MM') as order_month,
        SUM(order_amount) as total_order_amount
    from
        load_order
    group by
        order_month
    order by
        order_month
),

final as (
    select
        *
        -- 必要な列だけに絞り込もう: 月,売上
    from
        monthly_order
)

select *
from final
