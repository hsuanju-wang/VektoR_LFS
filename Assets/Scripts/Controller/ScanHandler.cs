using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ScanHandler : MonoBehaviour
{
    public Camera playerCamera;
    public Material originalSkybox;
    public Material scanSkybox;
    public GameObject scannerSphere;
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
            StartCoroutine(activateScanner());
        }
        else
        {
            //Deactivate Culling mask
            playerCamera.cullingMask = oldMask;
            RenderSettings.skybox = originalSkybox;
        }
        scannerActive = !scannerActive;
    }

    private IEnumerator activateScanner()
    {
        Instantiate(scannerSphere, new Vector3 (playerCamera.transform.position.x, 0f, playerCamera.transform.position.z), Quaternion.identity);
        yield return new WaitForSeconds(0.8f);
        int scanLayer = 1 << 10;
        playerCamera.cullingMask = scanLayer;
        RenderSettings.skybox = scanSkybox;
    }
}
