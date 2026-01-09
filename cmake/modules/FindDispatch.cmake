#.rst:
# FindLibRT
# ---------
#
# Find librt library and headers.
#
# The module defines the following variables:
#
# ::
#
# LibRT_FOUND       - true if librt was found
# LibRT_INCLUDE_DIR - include search path
# LibRT_LIBRARIES   - libraries to link

if(UNIX)
  find_path(dispatch_INCLUDE_DIR
            NAMES
              dispatch.h)
  find_library(Dispatch_LIBRARIES dispatch)

  include(FindPackageHandleStandardArgs)
  find_package_handle_standard_args(Dispatch
                                    REQUIRED_VARS
                                      Dispatch_LIBRARIES
                                      Dispatch_INCLUDE_DIR)

  if(Dispatch_FOUND)
    if(NOT TARGET Dispatch::dispatch)
      add_library(Dispatch::dispatch UNKNOWN IMPORTED)
      set_target_properties(Dispatch::dispatch
                            PROPERTIES
                              IMPORTED_LOCATION ${Dispatch_LIBRARIES}
                              INTERFACE_INCLUDE_DIRECTORIES ${Dispatch_INCLUDE_DIR})
    endif()
  endif()

  mark_as_advanced(Dispatch_LIBRARIES Dispatch_INCLUDE_DIR)
endif()

