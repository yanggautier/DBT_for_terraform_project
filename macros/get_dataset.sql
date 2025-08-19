{% macro get_dataset(layer) -%}
    {%- if target.name == 'prod' -%}
        {{ layer }}_prod
    {%- elif target.name == 'staging' -%}
        {{ layer }}_staging
    {%- else -%}
        {{ layer }}_dev
    {%- endif -%}
{%- endmacro %}