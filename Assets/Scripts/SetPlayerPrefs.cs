using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SetPlayerPrefs : MonoBehaviour
{
    // Start is called before the first frame update
    void Awake()
    {
        PlayerPrefs.SetString("BootStatus", "NotActivated");
        PlayerPrefs.SetString("ShowControllerHint", "NotDone");
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
