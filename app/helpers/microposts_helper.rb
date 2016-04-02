module MicropostsHelper
  def delete_link(item)
    if current_user?(item.user)
      link_to "delete", item, method: :delete,
        data: { confirm: "You sure?" },
        title: item.content
    end
  end
end
