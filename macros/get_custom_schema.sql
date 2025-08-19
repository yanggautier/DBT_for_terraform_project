{% macro generate_schema_name(custom_schema_name, node) -%}
    {% if custom_schema_name is none %}
        {{ target.schema }}
    {% else %}
        {% if target.name == 'prod' %}
            {{ custom_schema_name ~ '_prod' }}
        {% elif target.name == 'staging' %}
            {{ custom_schema_name ~ '_staging' }}
        {% else %}
            {{ custom_schema_name ~ '_dev' }}
        {% endif %}
    {% endif %}
{%- endmacro %}
