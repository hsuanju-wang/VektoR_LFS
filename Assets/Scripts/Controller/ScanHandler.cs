using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ScanHandler : MonoBehaviour
{
    public static ScanHandler s;

    public Camera playerCamera;
    public Material originalSkybox;
    public Material scanSkybox;
    public GameObject scannerSphere;
    public GameObject scannerObjects;

    public bool scannerActive = false;
    int oldMask;

    private void Awake()
    {
        if (s != null && s != this)
        {
            Destroy(this);
        }
        else
        {
            s = this;
        }
    }

    void Start()
    {
        oldMask = playerCamera.cullingMask;
    }

    void Update()
    {

    }

    public void Scan()
    {
        if (!scannerActive)
        {
            //Activate Culling mask
            StartCoroutine(activateScanner());
            scannerActive = true;
        }
    }

    private IEnumerator activateScanner()
    {
        Instantiate(scannerSphere, new Vector3 (playerCamera.transform.position.x, 0f, playerCamera.transform.position.z), Quaternion.identity);
        yield return new WaitForSeconds(0.8f);
        int scanLayer = 1 << 10;
        playerCamera.cullingMask = scanLayer;
        RenderSettings.skybox = scanSkybox;
        scannerObjects.SetActive(true);

        yield return new WaitForSeconds(3f);
        DeActivateScanner();
    }

    private void DeActivateScanner()
    {
        //Deactivate Culling mask
        playerCamera.cullingMask = oldMask;
        RenderSettings.skybox = originalSkybox;
        scannerObjects.SetActive(false);

        if (ControllerOutside.s.triggerClicked)
        {
            ControllerOutside.s.LaserOn();
        }
        scannerActive = false;
    }
}
