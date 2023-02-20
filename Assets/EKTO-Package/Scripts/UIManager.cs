using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;
using EKTO_Unity_Plugin;

public class UIManager : EktoEventListener
{
    public static UIManager S;

    public Button StartButton;

    public Image ServerConnection;
    public Image ServerDisconnection;

    private void Awake()
    {
        if (S != null && S != this) Destroy(this.gameObject);
        else S = this;
    }

    // Start is called before the first frame update
    void Start()
    {
        StartButton.enabled = true;
        ServerConnection.enabled = false;
        ServerDisconnection.enabled = true;
        EktoVRManager.S.ekto.AddEventListener(this);
    }
    private void Update()
    {
        if(EktoVRManager.S.ekto.IsServerConnected())
        {
            ServerConnection.enabled = true;
            ServerDisconnection.enabled = false;
        }
        else
        {
            ServerConnection.enabled = false;
            ServerDisconnection.enabled = true;
        }

        if(EktoVRManager.S.ekto.IsSystemActivated())
        {
            StartButton.GetComponentInChildren<TextMeshProUGUI>().text = "Stop";
        }
        else
        {
            StartButton.GetComponentInChildren<TextMeshProUGUI>().text = "Start";
        }
    }
}
