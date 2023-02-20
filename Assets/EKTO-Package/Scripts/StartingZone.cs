using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class StartingZone : MonoBehaviour
{
    public float ThetaScale = 0.01f;
    private float radius = 1.0f;
    private int Size;
    private LineRenderer LineDrawer;
    private float Theta = 0;

    void Start()
    {
        LineDrawer = GetComponent<LineRenderer>();
        LineDrawer.enabled = EktoVRManager.S.ekto.IsServerConnected();
    }

    void Update()
    {
        if (EktoVRManager.S.ekto.IsSystemActivated())
        {
            LineDrawer.enabled = false;
        }
        else if (EktoVRManager.S.ekto.IsServerConnected())
        {
            radius = EktoVRManager.S.ekto.GetStartingZoneRadius();
            LineDrawer.enabled = true;
        }
        else
        {
            LineDrawer.enabled = false;
        }
        Theta = 0f;
        Size = (int)((1.0f / ThetaScale) + 1.0f);
        LineDrawer.positionCount = Size;
        for (int i = 0; i < Size; i++)
        {
            Theta += (2.0f * Mathf.PI * ThetaScale);
            float x = radius * Mathf.Cos(Theta);
            float z = radius * Mathf.Sin(Theta);
            LineDrawer.SetPosition(i, new Vector3(x+transform.position.x, transform.position.y, z+transform.position.z));
        }
    }
}