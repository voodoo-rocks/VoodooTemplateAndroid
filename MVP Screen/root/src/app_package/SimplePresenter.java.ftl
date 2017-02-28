package ${packageName};

import android.support.annotation.NonNull;

public class ${name}Presenter implements ${contractName}.Presenter {
private ${contractName}.View view;

public ${name}Presenter(@NonNull ${contractName}.View view) {
this.view = view;
}

}
