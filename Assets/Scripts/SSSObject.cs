using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SSSObject : MonoBehaviour
{
    public bool m_bEnabled = false;

    [SerializeField]
    MeshRenderer[] m_arrmeshrendererThis;

    int m_iMaterialIndex = 0;

    private void Awake()
    {
        m_arrmeshrendererThis = GetComponentsInChildren<MeshRenderer>();
    }
    // Use this for initialization
    void Start ()
    {
        ToggleMeshes();
	}

    public void Toggle(Material[] _arrmatSSS)
    {
        if(!m_bEnabled)
        {
            m_bEnabled = true;
            ToggleMeshes();
            m_iMaterialIndex = 0;
            SetMeshMaterial(_arrmatSSS[m_iMaterialIndex]);
        }

        else
        {
            int iLen = _arrmatSSS.Length;
            if(m_iMaterialIndex + 1 < iLen)
            {
                m_iMaterialIndex++;
                //Debug.Log(gameObject.name + ": materialIndex is now: " + m_iMaterialIndex);
                SetMeshMaterial(_arrmatSSS[m_iMaterialIndex]);
            }
            else
            {
                m_iMaterialIndex = 0;
                m_bEnabled = false;
                ToggleMeshes();
            }
        }

    }

    void ToggleMeshes()
    {
        foreach (MeshRenderer mesh in m_arrmeshrendererThis)
        {
            mesh.enabled = m_bEnabled;
        }
    }

    void SetMeshMaterial(Material _mat)
    {
        foreach (MeshRenderer mesh in m_arrmeshrendererThis)
        {
            mesh.material = _mat;
        }
    }
}
