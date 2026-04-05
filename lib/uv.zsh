# shellcheck shell=bash
######################################################################
#<
#
# Function: p6_python_uv_tool_install(pkg)
#
#  Args:
#	pkg -
#
#  Environment:	 HOME
#>
######################################################################
p6_python_uv_tool_install() {
  local pkg="$1"

  (
    p6_dir_cd "$HOME"
    uv tool uninstall "$pkg"
    uv tool install "$pkg"
    uv tool list
  )

  p6_return_void
}
