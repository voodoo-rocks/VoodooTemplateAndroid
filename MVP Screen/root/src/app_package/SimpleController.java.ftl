package ${packageName};
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.annotation.NonNull;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

public class ${controllerName} extends BaseController implements ${contractName}.View {
private ${contractName}.Presenter presenter;

public static void attachToRouter(Router router) {
        Bundle bundle = new Bundle();

        ${controllerName} controller = new ${controllerName}(bundle);
        router.setRoot(RouterTransaction.with(controller));
    }

    public ${controllerName}(Bundle bundle){
    
    }

    @Override
    public void onAttach(View view) {
        super.onAttach(view);
        presenter = new ${name}Presenter(this);
    }


    @Nullable
    @Override
    public View inflateLayout(LayoutInflater inflater,
     @Nullable ViewGroup viewGroup) {
        return inflater.inflate(R.layout.${layoutController}, viewGroup, false);
    }

    @Override
    protected void onCreate(View view) {
        super.onCreate(view);
        
    }

}
