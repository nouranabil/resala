module BranchesHelper
  def info_summary(branch)
    %Q(
      <div>
        <h3>#{branch.name}</h3>
        <p><a href='javascript: showBranchData("#{branch.id}");' >#{t("messages.more_branches")}</a></p>
      </div>
    ).html_safe
  end
end