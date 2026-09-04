with final as (

    select
        user_id as user_id_hash
        , gender_name
        , age
        , state_name
        , marriage_status
        , profession_name
        , occupation_name

    from
        {{ source('rakuten_ec', 'users') }}

)

select *
from final
