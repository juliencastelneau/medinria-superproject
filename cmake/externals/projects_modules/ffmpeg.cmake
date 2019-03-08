################################################################################
#
# medInria
#
# Copyright (c) INRIA 2013. All rights reserved.
# See LICENSE.txt for details.
#
#  This software is distributed WITHOUT ANY WARRANTY; without even
#  the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
#  PURPOSE.
#
################################################################################

function(ffmpeg_project)
set(ep ffmpeg)

## #############################################################################
## List the dependencies of the project
## #############################################################################

list(APPEND ${ep}_dependencies
  )

## #############################################################################
## Prepare the project
## #############################################################################

EP_Initialisation(${ep}
  USE_SYSTEM OFF
  BUILD_SHARED_LIBS OFF
  REQUIRED_FOR_PLUGINS OFF
  )

if (NOT USE_SYSTEM_${ep})
## #############################################################################
## Set directories
## #############################################################################

EP_SetDirectories(${ep}
  EP_DIRECTORIES ep_dirs
  )

## #############################################################################
## Define repository where get the sources
## #############################################################################

if (WIN32)
  # MPEG2
  if (NOT DEFINED ${ep}_SOURCE_DIR)
    set(location URL "http://www.vtk.org/files/support/vtkmpeg2encode.zip")
  endif()
else()
  # FFMPEG
  set(tag "release/4.1")
  if (NOT DEFINED ${ep}_SOURCE_DIR)
	set(location GIT_REPOSITORY "${GITHUB_PREFIX}FFmpeg/FFmpeg.git" GIT_TAG ${tag})
  endif()
endif()

## #############################################################################
## Add external-project
## #############################################################################
if (WIN32)
  ExternalProject_Add(${ep}
    ${ep_dirs}
    ${location}
	CMAKE_GENERATOR ${gen}
	CMAKE_ARGS ${cmake_args}
	DEPENDS ${${ep}_dependencies}
	INSTALL_COMMAND ""
  )
else()
  ExternalProject_Add(${ep}
    ${ep_dirs}
    ${location}
    CONFIGURE_COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/${ep}/configure
		--disable-x86asm --disable-static 
		--disable-network --disable-zlib --disable-doc --disable-ffplay --disable-decoders
		--enable-shared --prefix=${CMAKE_CURRENT_SOURCE_DIR}/build/${ep}/build
    PREFIX ${CMAKE_CURRENT_SOURCE_DIR}/build/${ep}/build
    BUILD_COMMAND make install
  )
endif()

## #############################################################################
## Set variable to provide infos about the project
## #############################################################################

ExternalProject_Get_Property(${ep} binary_dir)
set(${ep}_DIR ${binary_dir} PARENT_SCOPE)

## #############################################################################
## Add custom targets
## #############################################################################

EP_AddCustomTargets(${ep})

endif() #NOT USE_SYSTEM_ep

endfunction()
