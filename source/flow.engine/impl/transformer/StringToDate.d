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
module flow.engine.impl.transformer.StringToDate;

import hunt.time.LocalDateTime;

import flow.engine.impl.transformer.AbstractTransformer;
import hunt.Exceptions;
/**
 * Transforms a {@link string} to a {@link Date}
 *
 * @author Esteban Robles Luna
 */
class StringToDate : AbstractTransformer {

    //protected FastDateFormat format = FastDateFormat.getInstance("dd/MM/yyyy");

    override
    protected Object primTransform(Object anObject)  {
        implementationMissing(false);
        return null;
       // return format.parse((string) anObject);
    }
}
