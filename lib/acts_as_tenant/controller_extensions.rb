module ActsAsTenant
  module ControllerExtensions
    autoload :Filter, "acts_as_tenant/controller_extensions/filter"
    autoload :Subdomain, "acts_as_tenant/controller_extensions/subdomain"
    autoload :SubdomainOrDomain, "acts_as_tenant/controller_extensions/subdomain_or_domain"
    autoload :SubdomainOrHost, "acts_as_tenant/controller_extensions/subdomain_or_host"
    autoload :DomainOrSubdomain, "acts_as_tenant/controller_extensions/domain_or_subdomain"
    autoload :HostOrSubdomain, "acts_as_tenant/controller_extensions/host_or_subdomain"

    # this method allows setting the current_tenant by reading the subdomain and looking
    # it up in the tenant-model passed to the method. The method will look for the subdomain
    # in a column referenced by the second argument.
    def set_current_tenant_by_subdomain(tenant = :account, column = :subdomain, subdomain_lookup: :last)
      include Subdomain

      self.tenant_class = tenant.to_s.camelcase.constantize
      self.tenant_column = column.to_sym
      self.subdomain_lookup = subdomain_lookup
    end

    # 01/27/2014 Christian Yerena / @preth00nker
    # this method adds the possibility of use the domain as a possible second argument to find
    # the current_tenant.
    def set_current_tenant_by_subdomain_or_domain(tenant = :account, primary_column = :subdomain, second_column = :domain, subdomain_lookup: :last)
      include SubdomainOrDomain

      self.tenant_class = tenant.to_s.camelcase.constantize
      self.tenant_primary_column = primary_column.to_sym
      self.tenant_second_column = second_column.to_sym
      self.subdomain_lookup = subdomain_lookup
    end

    # this method adds the possibility of use the request.host as a possible second argument to find
    # the current_tenant.
    def set_current_tenant_by_subdomain_or_host(tenant = :account, primary_column = :subdomain, second_column = :domain, subdomain_lookup: :last)
      include SubdomainOrHost

      self.tenant_class = tenant.to_s.camelcase.constantize
      self.tenant_primary_column = primary_column.to_sym
      self.tenant_second_column = second_column.to_sym
      self.subdomain_lookup = subdomain_lookup
    end

    # this method adds the possibility of use the request.host as a possible second argument to find
    # the current_tenant.
    def set_current_tenant_by_domain_or_subdomain(tenant = :account, primary_column = :subdomain, second_column = :domain, subdomain_lookup: :last)
      include DomainOrSubdomain

      self.tenant_class = tenant.to_s.camelcase.constantize
      self.tenant_primary_column = primary_column.to_sym
      self.tenant_second_column = second_column.to_sym
      self.subdomain_lookup = subdomain_lookup
    end

    # this method adds the possibility of use the request.host as a possible second argument to find
    # the current_tenant.
    def set_current_tenant_by_host_or_subdomain(tenant = :account, primary_column = :subdomain, second_column = :domain, subdomain_lookup: :last)
      include HostOrSubdomain

      self.tenant_class = tenant.to_s.camelcase.constantize
      self.tenant_primary_column = primary_column.to_sym
      self.tenant_second_column = second_column.to_sym
      self.subdomain_lookup = subdomain_lookup
    end

    # This method sets up a method that allows manual setting of the current_tenant. This method should
    # be used in a before_action. In addition, a helper is setup that returns the current_tenant
    def set_current_tenant_through_filter
      include Filter
    end
  end
end
