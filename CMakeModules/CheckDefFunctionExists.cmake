include (CheckFunctionExists)

MACRO(CHECK_DEF_FUNCTION_EXISTS FUNCTION VARIABLE)
    CHECK_FUNCTION_EXISTS(${FUNCTION} ${VARIABLE})
    IF(${VARIABLE})
        ADD_DEFINITIONS(-D${VARIABLE})
    ENDIF(${VARIABLE})
ENDMACRO(CHECK_DEF_FUNCTION_EXISTS)