module ActsAsTenant
  module ControllerExtensions
    module DomainOrSubdomain
      extend ActiveSupport::Concern

      included do
        cattr_accessor :tenant_class, :tenant_primary_column, :tenant_second_column, :subdomain_lookup
        before_action :find_tenant_by_domain_or_subdomain
      end

      private

      def find_tenant_by_domain_or_subdomain
        subdomain = request.subdomains.send(subdomain_lookup)
        query = subdomain.present? ? {tenant_primary_column => subdomain.downcase} : {tenant_second_column => request.domain.downcase}
        domain_query = {tenant_second_column => request.domain.downcase}
        puts "subdomain: #{subdomain}"
        puts "query: #{query}"
        puts "domain_query: #{domain_query}"

        # AREL EXAMPLE WITH NULLS LAST
        # ActsAsTenant.current_tenant = tenant_class.where(query).or(tenant_class.where(domain_query)).order(tenant_class.arel_table[tenant_second_column].desc.nulls_last).first

        # COALESCE EXAMPLE
        # order_query = "COALESCE(#{tenant_second_column}, 'fallback_value') desc"
        # ActsAsTenant.current_tenant = tenant_class.where(query).or(tenant_class.where(domain_query)).order(Arel.sql(order_query)).first


        # CASE EXAMPLE
        case_statement = <<-SQL.squish
           CASE
              WHEN %s IS NULL THEN 2
              ELSE 1
           END
           , %s DESC
        SQL
        sanitized_case_statement = ActiveRecord::Base.sanitize_sql_array(
          [case_statement, tenant_second_column, tenant_second_column]
        )
        ActsAsTenant.current_tenant = tenant_class.where(query).or(tenant_class.where(domain_query)).order(Arel.sql(sanitized_case_statement)).first





      end
    end
  end
end
