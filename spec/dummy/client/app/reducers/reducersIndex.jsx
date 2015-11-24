import helloWorldReducer from './helloWorldReducer';
import {initialState as helloWorldState} from './helloWorldReducer';

// This is how you do a directory of reducers.
// The `import * as reducers` does not work for a directory, but only with a single file
export default { helloWorldData: helloWorldReducer };

export const initialStates = {
  helloWorldState,
};
