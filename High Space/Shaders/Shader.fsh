//
//  Shader.fsh
//  High Space
//
//  Created by Chris Luttio on 7/26/16.
//  Copyright © 2016 Chris Luttio. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
