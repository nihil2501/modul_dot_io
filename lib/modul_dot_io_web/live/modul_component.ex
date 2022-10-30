defmodule ModulDotIoWeb.ModulComponent do
  use ModulDotIoWeb, :live_component

  def render(assigns) do
    ~H"""
    <section id="modul">
      <div id="chassis">
        <select name="pets" id="pet-select">
          <option value=""></option>
          <option value="dog">Load</option>
          <option value="cat">Save</option>
          <option value="hamster">Hamster</option>
          <option value="parrot">Parrot</option>
          <option value="spider">Spider</option>
          <option value="goldfish">Goldfish</option>
        </select>
        <div class="button-container">
          <button>Load</button>
        </div>
        <div class="button-container">
          <button>Save</button>
        </div>
      </div>
    </section>
    """
  end
end
