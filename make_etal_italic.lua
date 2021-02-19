return {
  {
    Str = function (elem)
      if elem.text == "et al." then
        return pandoc.Emph {pandoc.Str "et al."}
      else
        return elem
      end
    end,
  }
}
