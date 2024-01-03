-- Bloco Snapshot para o campo username e followers_count
{% snapshot instagram_user_snapshot %}
{{
  config(
    unique_key='username',
    strategy='timestamp',
    target_schema='instagram_analytics',
    updated_at='updated_at'
  )
}}
select
    u.username,
    u.followers_count,
    u._airbyte_extracted_at as updated_at
from `begin-data.instagram_raw.users` as u
{% endsnapshot %}
