--[[
	节点类
	Author: H.X.Sun
]]

local NodeUtil = {}
--[[--
--节点变灰
--@param node 想要改变节点(控件)
--@param flag  是否变灰
--]]
function NodeUtil:darkNode(node, flag)
    if not tolua.cast(node,"cc.Node") then
        print("参数node不是一个节点")
        return
    end

    if flag then
        local vertDefaultSource = [[

            attribute vec4 a_position;
            attribute vec2 a_texCoord;
            attribute vec4 a_color;

            #ifdef GL_ES
                varying lowp vec4 v_fragmentColor;
                varying mediump vec2 v_texCoord;
            #else
                varying vec4 v_fragmentColor;
                varying vec2 v_texCoord;
            #endif

            void main()
            {
                gl_Position = CC_PMatrix * a_position;
                v_fragmentColor = a_color;
                v_texCoord = a_texCoord;
            }

        ]]

        local pszFragSource = [[

            #ifdef GL_ES
                precision mediump float;
            #endif
            varying vec4 v_fragmentColor;
            varying vec2 v_texCoord;

            void main(void)
            {
                vec4 c = texture2D(CC_Texture0, v_texCoord);
                gl_FragColor.xyz = vec3(0.4*c.r + 0.4*c.g +0.4*c.b);
                gl_FragColor.w = c.w;
            }

        ]]

        local pProgram = cc.GLProgram:createWithByteArrays(vertDefaultSource, pszFragSource)

        pProgram:bindAttribLocation(cc.ATTRIBUTE_NAME_POSITION, cc.VERTEX_ATTRIB_POSITION)
        pProgram:bindAttribLocation(cc.ATTRIBUTE_NAME_COLOR, cc.VERTEX_ATTRIB_COLOR)
        pProgram:bindAttribLocation(cc.ATTRIBUTE_NAME_TEX_COORD, cc.VERTEX_ATTRIB_FLAG_TEX_COORDS)
        pProgram:link()
        pProgram:updateUniforms()
        node:setGLProgram(pProgram)
    else
        node:setGLProgramState(cc.GLProgramState:getOrCreateWithGLProgram(cc.GLProgramCache:getInstance():getGLProgram("ShaderPositionTextureColor_noMVP")))
    end
end

return NodeUtil
