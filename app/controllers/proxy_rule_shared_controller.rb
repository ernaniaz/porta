# frozen_string_literal: true

# This module is used to share behavior between the 2 different Mapping rules controller that we have
# (1 for BackendApi and another one to the Proxy).
# The controller that uses this class should implement the `proxy_rules` method that returns a relation containing all
# the mapping rules for the resource.
module ProxyRuleSharedController
  def self.included(base)
    base.class_eval do
      before_action :find_proxy_rule, only: %i[edit update destroy]
    end
  end

  def index
    @presenter = Api::ProxyRulesIndexPresenter.new(proxy: proxy,
                                                   params: params)
  end

  def new
    last_position = proxy_rules.maximum(:position) || 0
    next_position = last_position + 1
    @proxy_rule = proxy_rules.build(position: next_position, delta: 1)
  end

  private

  def find_proxy_rule
    @proxy_rule = proxy_rules.find(params[:id])
  end

  def proxy_rule_params
    params.require(:proxy_rule).permit(%i[http_method pattern delta metric_id position last redirect_url])
  end
end
