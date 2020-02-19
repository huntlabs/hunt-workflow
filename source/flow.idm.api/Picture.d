/* Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

//          Copyright linse 2020. 
// Distributed under the Boost Software License, Version 1.0. 
//    (See accompanying file LICENSE_1_0.txt or copy at 
//          http://www.boost.org/LICENSE_1_0.txt)} 
 
module flow.idm.api.Picture;
 
 
 


import hunt.io.ByteArrayInputStream;
import hunt.io.Common;

/**
 * @author Tom Baeyens
 */
class Picture  {

    private static  long serialVersionUID = 2384375526314443322L;

    protected byte[] bytes;
    protected string mimeType;

    this(byte[] bytes, string mimeType) {
        this.bytes = bytes;
        this.mimeType = mimeType;
    }

    public byte[] getBytes() {
        return bytes;
    }

    public InputStream getInputStream() {
        return new ByteArrayInputStream(bytes);
    }

    public string getMimeType() {
        return mimeType;
    }
}
