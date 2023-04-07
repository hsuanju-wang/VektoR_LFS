using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ScanHandler : MonoBehaviour
{
    public Camera playerCamera;
    public Material originalSkybox;
    public Material scanSkybox;
    private bool scannerActive = false;
    int oldMask;

    // Start is called before the first frame update
    void Start()
    {
        oldMask = playerCamera.cullingMask;
    }

    // Update is called once per frame
    void Update()
    {

    }

    public void Scan()
    {
        if (scannerActive)
        {
            //Activate Culling mask
            int scanLayer = 1 << 10;
            playerCamera.cullingMask = scanLayer;
            RenderSettings.skybox = scanSkybox;
        }
        else
        {
            //Deactivate Culling mask
            playerCamera.cullingMask = oldMask;
            RenderSettings.skybox = originalSkybox;
        }
        scannerActive = !scannerActive;
    }
}
