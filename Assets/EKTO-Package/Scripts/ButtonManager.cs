using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ButtonManager : MonoBehaviour
{
    public static ButtonManager S;
    private void Awake()
    {
        if (S != null && S != this) Destroy(this.gameObject);
        else S = this;
    }

    public void btn_OnStart()
    {
        if (!EktoVRManager.S.ekto.IsSystemActivated())
        {
            EktoVRManager.S.ekto.StartSystem();
        }
        else
        {
            EktoVRManager.S.ekto.StopSystem();
        }
    }
}
